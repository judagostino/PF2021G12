import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { TypeImpairment } from '../interfaces';
import { ContactTypeImpairment } from '../interfaces/contact-type-impairment';

@Injectable({
  providedIn: 'root'
})
export class ContactTypeImpairmentService {
  URL: string = '';

  constructor(public http: HttpClient) { 
    this.URL = `${environment.URL}/ContactTypeImplairment`;
  }

  public getAlll(): Observable<ContactTypeImpairment[]> {
    let headers= new HttpHeaders();
    headers = headers.append('Content-Type', 'application/json');
    return this.http.get(`${this.URL}`, {headers}).pipe(map((response) => response as ContactTypeImpairment[]));
  }

  public insert(types:number []): Observable<any> {
    let headers= new HttpHeaders();
    headers = headers.append('Content-Type', 'application/json');
    return this.http.post(`${this.URL}`,{types}, {headers});
  }

  public update(types:number [],id:number): Observable<any> {
    let headers= new HttpHeaders();
    headers = headers.append('Content-Type', 'application/json');
    return this.http.put(`${this.URL}/${id}`,{types}, {headers});
  }
}
