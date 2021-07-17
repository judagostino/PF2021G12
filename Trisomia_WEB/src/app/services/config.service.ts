import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { catchError, map, mergeMap } from 'rxjs/operators';
import { AuthService } from './auth.service';

@Injectable()
export class ConfigService {
  public isLooged:boolean = false;

  constructor(public authService: AuthService) {

  }

  public load(): Promise<void> {
    return new Promise((resolve) => {
      this.reAuthenticate().pipe(
        mergeMap((isLooged: boolean) => {
          this.isLooged = isLooged;
          return of(isLooged);
        })
      ).subscribe((loadData) => resolve());
    });
  }

  private reAuthenticate(): Observable<boolean> {
    if (this.authService.getAccessToken() != null && this.authService.getAccessToken() != undefined) {
      return this.authService.reAuthentricate().pipe(map(() => true, catchError(err => of(false))))
    } else {
      return of(false);
    }
  }
}
