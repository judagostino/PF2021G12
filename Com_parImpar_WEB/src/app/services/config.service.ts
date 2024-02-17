import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { catchError, map, mergeMap } from 'rxjs/operators';
import { ContactService } from './contact.service';
import { Contact } from '../interfaces';
import { AuthService } from './auth.service';

@Injectable()
export class ConfigService {
  public isLogged:boolean = false;
  public contact:Contact = null;

  constructor(public authService: AuthService, private contactService:ContactService) {

  }

  public load(): Promise<void> {
    return new Promise((resolve) => {
      this.reAuthenticate().pipe(
        mergeMap((isLogged: boolean) => {
          this.isLogged = isLogged;
          if(isLogged){
            return this.contactService.myInfo().pipe(map(res =>{
              this.contact = res;
              return true;
            }))
          } else {
            return of(isLogged);
          }
        })
      ).subscribe((loadData) => resolve(), err => {
        this.isLogged = false;
        resolve()}
        );
    });
    //return new Promise((resolve) => resolve(null))
  }

  public dafaultImage(): string {
    return '/assets/image/not_found.png';
  }

  private reAuthenticate(): Observable<boolean> {
    if (this.authService.getAccessToken() != null && this.authService.getAccessToken() != undefined) {
      return this.authService.reAuthentricate().pipe(map(() => true, catchError(err => of(false))))
    } else {
      return of(false);
    }
  }
}
