import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import { HttpKey } from '../constans';
import { ContactRegistrer } from '../models/contact-register';

@Injectable({
  providedIn: 'root'
})
export class ContactService {
  URL: string = '';

  constructor(public http: HttpClient) { 
    this.URL = `${environment.URL}/Contact`;
  }

  public registrerUser(register: ContactRegistrer): Observable<any> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.SKIP_INTERCEPTOR, '');

    return this.http.post(`${this.URL}/Register`, register, {headers});
  }

  public confirmUser(register: ContactRegistrer): Observable<any> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.SKIP_INTERCEPTOR, '');

    return this.http.post(`${this.URL}/Confirm`, register, {headers});
  }

  public recoverPassword(register: ContactRegistrer): Observable<any> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.SKIP_INTERCEPTOR, '');

    return this.http.post(`${this.URL}/Recover`, register, {headers});
  }

  public denyPasswordUser(register: ContactRegistrer): Observable<any> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.SKIP_INTERCEPTOR, '');

    return this.http.post(`${this.URL}/Deny`, register, {headers});
  }


  public validateRecover(register: ContactRegistrer): Observable<any> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.SKIP_INTERCEPTOR, '');

    return this.http.post(`${this.URL}/Validate`, register, {headers});
  }


  public recoverChangePassword(register: ContactRegistrer): Observable<any> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.SKIP_INTERCEPTOR, '');

    return this.http.post(`${this.URL}/RecoverChange`, register, {headers});
  }

  public myInfo(): Observable<any> {
    return this.http.get(`${this.URL}/myInfo`);
  }

}