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
    return this.http.get(`${this.URL}/${id}`).pipe(map((response:Post) => {
      if(response.description != null) {
        response.description = response.description.replace(/<br\s*\/?>/g, '\n');
        response.descriptionParagraphs = response.description.split('\n');
      }
      if(response.text != null) {
        response.text = response.text.replace(/<br\s*\/?>/g, '\n');
        response.bodyParagraphs = response.text.split('\n');
      }
      return response;
    }));
  }

  public getByIdMoreInfo(id: number): Observable<Post> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.SKIP_INTERCEPTOR, '');

    return this.http.get(`${this.URL}/${id}/moreInfo`, {headers}).pipe(map((response:Post) => {
      if(response.description != null) {
        response.description = response.description.replace(/<br\s*\/?>/g, '\n');
        response.descriptionParagraphs = response.description.split('\n');
      }
      if(response.text != null) {
        response.text = response.text.replace(/<br\s*\/?>/g, '\n');
        response.bodyParagraphs = response.text.split('\n');
      }
      return response;
    }));
  }

  public insert(post: Post): Observable<Post> {
    if(post.description != null) {
      post.description = post.description.replace(/\n/g, '<br>');
    }

    if(post.text != null) {
      post.text = post.text.replace(/\n/g, '<br>');
    }

    return this.http.post(`${this.URL}`, post).pipe(map((response:Post) => {
      if(response.description != null) {
        response.description = response.description.replace(/<br\s*\/?>/g, '\n');
        response.descriptionParagraphs = response.description.split('\n');
      }
      if(response.text != null) {
        response.text = response.text.replace(/<br\s*\/?>/g, '\n');
        response.bodyParagraphs = response.text.split('\n');
      }
      return response;
    }));
  }

  public update(id: number, post: Post): Observable<Post> {
    if(post.description != null) {
      post.description = post.description.replace(/\n/g, '<br>');
    }

    if(post.text != null) {
      post.text = post.text.replace(/\n/g, '<br>');
    }

    return this.http.put(`${this.URL}/${id}`, post).pipe(map((response:Post) => {
      if(response.description != null) {
        response.description = response.description.replace(/<br\s*\/?>/g, '\n');
        response.descriptionParagraphs = response.description.split('\n');
      }
      if(response.text != null) {
        response.text = response.text.replace(/<br\s*\/?>/g, '\n');
        response.bodyParagraphs = response.text.split('\n');
      }
      return response;
    }));
  }

  public delete(id: number): Observable<any> {
    return this.http.delete(`${this.URL}/${id}`);
  }

  public getAll(audit: boolean = false): Observable<Post[]> {
    return this.http.get(`${this.URL}${audit ? '?a=1' : ''}`).pipe(map((response:Post[]) => {
      response.forEach(post => {
        if(post.description != null) {
          post.description = post.description.replace(/<br\s*\/?>/g, '\n');
          post.descriptionParagraphs = post.description.split('\n');
        }
        if(post.text != null) {
          post.text = post.text.replace(/<br\s*\/?>/g, '\n');
          post.bodyParagraphs = post.text.split('\n');
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
}
