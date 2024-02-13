import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { catchError, map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { ContactEvents } from '../models/contact-events';

@Injectable({
  providedIn: 'root'
})
export class ContactEventsService {
  URL: string = '';

  constructor(public http: HttpClient) { 
    this.URL = `${environment.URL}/ContactEvents`;
  }

  public getAllAssist(): Observable<ContactEvents[]> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    return this.http.get(`${this.URL}`, {headers}).pipe(map(response => {
      let data = response as ContactEvents[];
      return data;
    }));
  }

  public getAssist(id:number): Observable<ContactEvents> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    return this.http.get(`${this.URL}/${id}`, {headers}).pipe(map(response => {
      let data = response as ContactEvents;
      return data;
    }));
  }

  public postAssist(id:number): Observable<ContactEvents> {
    let headers= new HttpHeaders();
    
    headers = headers.append('Content-Type', 'application/json');
    return this.http.post(`${this.URL}`,{eventId:id},{headers}).pipe(map(response => {
      let data = response as ContactEvents;
      return data;
    }));
  }
  
  public cancelAssist(id:number): Observable<ContactEvents> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    return this.http.delete(`${this.URL}/${id}`,{headers}).pipe(map(response => {
      let data = response as ContactEvents;
      return data;
    }));
  }
}

