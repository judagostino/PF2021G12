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

  public getById(id: number): Observable<Post> {
    return this.http.get(`${this.URL}/${id}`).pipe(map((response:Post) => response));
  }

  public getByIdMoreInfo(id: number): Observable<Post> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.SKIP_INTERCEPTOR, '');

    return this.http.get(`${this.URL}/${id}/moreInfo`, {headers}).pipe(map((response:Post) => response));
  }

  public insert(event: Post): Observable<Post> {
    return this.http.post(`${this.URL}`, event).pipe(map((response:Post)=> response));
  }

  public update(id: number, event: Post): Observable<Post> {
    return this.http.put(`${this.URL}/${id}`, event).pipe(map((response:Post) => response));
  }

  public delete(id: number): Observable<any> {
    return this.http.delete(`${this.URL}/${id}`);
  }

  public getAll(): Observable<Post[]> {
    return this.http.get(`${this.URL}`).pipe(map((response:Post[]) => response));
  }

  public authorize(id: number): Observable<any> {
    return this.http.post(`${this.URL}/${id}/Autorize`, {});
  }

  public deny(id: number): Observable<any> {
    return this.http.post(`${this.URL}/${id}/Deny`, {});
  }
}
