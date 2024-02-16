import { Injectable } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor,
  HttpErrorResponse
} from '@angular/common/http';
import { Observable, Subject, throwError } from 'rxjs';
import { catchError, switchMap } from 'rxjs/operators';
import { AuthService } from '../services';
import { HttpKey } from '../constans';
import { Router } from '@angular/router';

@Injectable()
export class HttpParImparInterceptor implements HttpInterceptor {
  private refreshSubject: Subject<any> = new Subject<any>();

  constructor(
    private authService: AuthService,
    private router: Router) {}

  intercept(request: HttpRequest<unknown>, next: HttpHandler): Observable<HttpEvent<unknown>> {
    let newRequest = request;

    if (request.headers.get(HttpKey.SKIP_INTERCEPTOR) !== undefined && request.headers.get(HttpKey.SKIP_INTERCEPTOR)  !== null) {
      const newHeaders = request.headers.delete("Anonympus");
      newRequest = request.clone({headers: newHeaders});

      return next.handle(newRequest).pipe(
        catchError((error) => {
          if( error instanceof HttpErrorResponse) {
            if (this.isTokenExpiryError(error)) {
              return this.managementError(error);
            }
          }
          return this.managementError(error);
        })
      )
    } else if (request.headers.get(HttpKey.AUTHORIZE_AS_POSSIBLE) !== undefined && request.headers.get(HttpKey.AUTHORIZE_AS_POSSIBLE)  !== null) {
      const newHeaders = request.headers.delete("authorize_as_possible");
      if (this.authService.getAccessToken() != null && this.authService.getAccessToken() != undefined) {
        newRequest = request.clone({headers: newHeaders});
        newRequest = this.updateHeader(request);
      } else {
        return next.handle(newRequest).pipe(
          catchError((error) => {
            if( error instanceof HttpErrorResponse) {
              if (this.isTokenExpiryError(error)) {
                return this.managementError(error);
              }
            }
            return this.managementError(error);
          })
        )
      }
    } else  {
      newRequest = this.updateHeader(request);
    }

    return next.handle(newRequest).pipe(
      catchError((error, caught) => {
        if (error instanceof HttpErrorResponse) {
          if (this.isTokenExpiryError(error)) {
            return this.tokenExpired().pipe(
              switchMap(() => {
                return next.handle(this.updateHeader(newRequest)).pipe(
                  catchError((errorAfterRefresh) => {
                    if (errorAfterRefresh instanceof HttpErrorResponse && this.isTokenExpiryError(errorAfterRefresh)) {
                      this.clearAndRedirect();
                    }
                    return this.managementError(errorAfterRefresh);
                  })
                );
              })
            );
          } else if (this.isTokenExpiryError(error)) {
            this.clearAndRedirect();
          }
          return this.managementError(error);
        }
        return caught;
      })
    );
  }

  private clearAndRedirect(): void {
    this.router.navigate(['/login']);
    this.authService.cleartokens();
  }


  private isTokenExpiryError(error: HttpErrorResponse): boolean {
    return (error.status && error.status == 401);
  } 

  private managementError(error: HttpErrorResponse) {
    return throwError(error);
  } 

  private updateHeader(req: HttpRequest<any>){
    const authToken = this.authService.getAccessToken();
    if (authToken !== undefined || authToken !== null) {
      req = req.clone({
        headers: req.headers.set('Authorization', `Bearer ${authToken}`)
      })
      return req;
    }
  }

  private tokenExpired(): Subject<any> {
    this.refreshSubject.subscribe({
      complete: () => {
        this.refreshSubject = new Subject<any>();
      }
    });
    if (this.refreshSubject.observers.length === 1) {
      this.authService.reAuthentricate().subscribe(this.refreshSubject)
    }
    return this.refreshSubject;
  }
}
