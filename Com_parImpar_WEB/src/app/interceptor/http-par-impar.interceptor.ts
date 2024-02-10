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

@Injectable()
export class HttpParImparInterceptor implements HttpInterceptor {
  private refreshSubject: Subject<any> = new Subject<any>();

  constructor(private authSrervice: AuthService) {}

  intercept(request: HttpRequest<unknown>, next: HttpHandler): Observable<HttpEvent<unknown>> {
    let newRequest = request;

    if (request.headers.get(HttpKey.SKIP_INTERCEPTOR) !== undefined && request.headers.get(HttpKey.SKIP_INTERCEPTOR)  !== null) {
      const newHeaders = request.headers.delete("Anonympus");
      newRequest = request.clone({headers: newHeaders});

      return next.handle(newRequest).pipe(
        catchError((error) => {
          if( error instanceof HttpErrorResponse) {
            if (this.isTokenExpiryError(error)) {
              return this.managementErrror(error);
            }
          }
          return this.managementErrror(error);
        })
      )
    } else if (request.headers.get(HttpKey.AUTHORIZE_AS_POSSIBLE) !== undefined && request.headers.get(HttpKey.AUTHORIZE_AS_POSSIBLE)  !== null) {
      const newHeaders = request.headers.delete("authorize_as_possible");
      if (this.authSrervice.getAccessToken() != null && this.authSrervice.getAccessToken() != undefined) {
        newRequest = request.clone({headers: newHeaders});
        newRequest = this.updateHeader(request);
      } else {
        return next.handle(newRequest).pipe(
          catchError((error) => {
            if( error instanceof HttpErrorResponse) {
              if (this.isTokenExpiryError(error)) {
                return this.managementErrror(error);
              }
            }
            return this.managementErrror(error);
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
              switchMap( () => {
                return next.handle(this.updateHeader(newRequest));
              })
            )
          } else {
            return this.managementErrror(error);
          }
        }
        return caught;
      })
    );
  }


  private isTokenExpiryError(error: HttpErrorResponse): boolean {
    return (error.status && error.status == 401);
  } 

  private managementErrror(error: HttpErrorResponse) {
    return throwError(error);
  } 

  private updateHeader(req: HttpRequest<any>){
    const authToken = this.authSrervice.getAccessToken();
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
      this.authSrervice.reAuthentricate().subscribe(this.refreshSubject)
    }
    return this.refreshSubject;
  }
}
