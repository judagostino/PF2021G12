import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { HttpKey } from '../constans';
import { AuthenticationTokens, CredencialLogin, HttpResponse } from '../intrergaces';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  URL: string = '';

  private refreshToken: string = localStorage.getItem('pi_rt');
  private accessToken: string = localStorage.getItem('pi_at');
  private expTime: number = Number.parseInt(localStorage.getItem('pi_etr' ));

  constructor(public http: HttpClient) { 
    this.URL = `${environment.URL}/Auth`;
  }

  public credentialLogin(credencialLogin: CredencialLogin): Observable<any> {
    this.cleartokens();

    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.SKIP_INTERCEPTOR, '');

    return this.http.post(`${this.URL}/CredentialsLogin`, credencialLogin, {headers}).pipe(
      map((response:HttpResponse<AuthenticationTokens, any>) => this.setSession(response.data))
    );
  }

  public reAuthentricate(): Observable<any|null> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.SKIP_INTERCEPTOR, '');

    if (localStorage.getItem('pi_at')) {
      this.accessToken = localStorage.getItem('pi_at');
    }

    if (localStorage.getItem('pi_rt')) {
      this.refreshToken = localStorage.getItem('pi_rt');
    }

    headers = headers.append('Authorization', `Bearer ${this.refreshToken}`);

    return this.http.post(`${this.URL}/Update`, {access: this.accessToken}, {headers}).pipe(
      map((response:HttpResponse<AuthenticationTokens, any>) => this.setSession(response.data))
    );
  }

  public getAccessToken(): string | undefined {
    return this.accessToken || undefined;
  }

  public cleartokens() {
    localStorage.clear();
  }

  private setSession (response: AuthenticationTokens) {
    if (response.expiresIn !== 0) {
      const expDate = new Date();
      expDate.setTime(expDate.getTime() + ((response.expiresIn - 60) * 1000));
      this.expTime = expDate.getTime();
  
      localStorage.setItem('pi_etr' , this.expTime.toString());
    }
   

    this.accessToken = response.accessToken;
    this.refreshToken = response.refreshToken;
    
    localStorage.setItem('pi_rt' , this.refreshToken);
    localStorage.setItem('pi_at' , this.accessToken);
  }
}
