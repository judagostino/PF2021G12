import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import { HttpKey } from '../constans';
import { Register } from '../models/register';

@Injectable({
  providedIn: 'root'
})
export class RegisterService {
  URL: string = '';

  constructor(public http: HttpClient) { 
    this.URL = `${environment.URL}/Contact`;
  }

  public register(register: Register): Observable<any> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.SKIP_INTERCEPTOR, '');
    
    return this.http.post(`${this.URL}/Register`, register, {headers});
  }
  
  
}