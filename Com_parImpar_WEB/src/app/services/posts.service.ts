import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { HttpKey } from '../constans';
import { Post } from '../models/post';

@Injectable({
  providedIn: 'root'
})
export class PostsService {
  URL: string = '';

  constructor(public http: HttpClient) { 
    this.URL = `${environment.URL}/Posts`;
  }

  public getById(id: number): Observable<any> {
    return this.http.get(`${this.URL}/${id}`);
  }

  public getByIdMoreInfo(id: number): Observable<any> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.SKIP_INTERCEPTOR, '');

    return this.http.get(`${this.URL}/${id}/moreInfo`, {headers});
  }

  public insert(event: Post): Observable<any> {
    return this.http.post(`${this.URL}`, event);
  }

  public update(id: number, event: Post): Observable<any> {
    return this.http.put(`${this.URL}/${id}`, event);
  }

  public delete(id: number): Observable<any> {
    return this.http.delete(`${this.URL}/${id}`);
  }

  public getAll(): Observable<any[]> {
    return this.http.get(`${this.URL}`).pipe(map((response:Post[]) => response));
  }

  public authorize(id: number): Observable<any> {
    return this.http.post(`${this.URL}/${id}/Autorize`, {});
  }

  public deny(id: number, reason: string): Observable<any> {
    return this.http.post(`${this.URL}/${id}/Deny`, {reason});
  }
}
