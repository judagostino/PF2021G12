import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { HttpKey } from '../constans';
import { Events } from '../models/events';

@Injectable({
  providedIn: 'root'
})
export class EventsService {
  URL: string = '';

  constructor(public http: HttpClient) { 
    this.URL = `${environment.URL}/Events`;
  }

  public getById(id: number): Observable<Events> {
    return this.http.get(`${this.URL}/${id}`).pipe(map((response:Events) => {
      if(response.description != null) {
        response.description = response.description.replace(/<br\s*\/?>/g, '\n');
        response.descriptionParagraphs = response.description.split('\n');
      }
      return response;
    }));
  }

  public getByIdMoreInfo(id: number): Observable<Events> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.AUTHORIZE_AS_POSSIBLE, '');

    return this.http.get(`${this.URL}/${id}/moreInfo`, {headers}).pipe(map((response:Events) => {
      if(response.description != null) {
        response.description = response.description.replace(/<br\s*\/?>/g, '\n');
        response.descriptionParagraphs = response.description.split('\n');
      }
      return response;
    }));
  }

  public insert(event: Events): Observable<Events> {
    if(event.description != null) {
      event.description = event.description.replace(/\n/g, '<br>');
    }
    return this.http.post(`${this.URL}`, event).pipe(map((response:Events) => {
      if(response.description != null) {
        response.description = response.description.replace(/<br\s*\/?>/g, '\n');
        response.descriptionParagraphs = response.description.split('\n');
      }
      return response;
    }));
  }

  public update(id: number, event: Events): Observable<Events> {
    if(event.description != null) {
      event.description = event.description.replace(/\n/g, '<br>');
    }
    return this.http.put(`${this.URL}/${id}`, event).pipe(map((response:Events) => {
      if(response.description != null) {
        response.description = response.description.replace(/<br\s*\/?>/g, '\n');
        response.descriptionParagraphs = response.description.split('\n');
      }
      return response;
    }));
  }

  public delete(id: number): Observable<any> {
    return this.http.delete(`${this.URL}/${id}`);
  }

  public getAll(audit: boolean = false): Observable<Events[]> {
    return this.http.get(`${this.URL}${audit ? '?a=1' : ''}`).pipe(map((response:Events[]) => {
      response.forEach(event => {
        if(event.description != null) {
          event.description = event.description.replace(/<br\s*\/?>/g, '\n');
          event.descriptionParagraphs = event.description.split('\n');
        }
      });
      return response;
    }));
  }

  public authorize(id: number): Observable<any> {
    return this.http.post(`${this.URL}/${id}/Autorize`, {});
  }

  public deny(id: number, reason: string): Observable<any> {
    return this.http.post(`${this.URL}/${id}/Deny`, {reason});
  }

  public getByDate(date: Date): Observable<Events[]> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.AUTHORIZE_AS_POSSIBLE, '');

    return this.http.get(`${this.URL}/Date?d=${date.getFullYear()}-${date.getMonth() + 1}-${1}`
    , {headers}).pipe(map((response:Events[]) => {
      response.forEach(event => {
        if(event.description != null) {
          event.description = event.description.replace(/<br\s*\/?>/g, '\n');
          event.descriptionParagraphs = event.description.split('\n');
        }
      });
      return response;
    }));
  }
}
