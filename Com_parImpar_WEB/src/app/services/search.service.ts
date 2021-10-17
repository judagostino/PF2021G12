import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { HttpKey } from '../constans';
import { SearchItem, TypeImpairment } from '../intrergaces';

@Injectable({
  providedIn: 'root'
})
export class SearchService {
  URL: string = '';

  constructor(public http: HttpClient) { 
    this.URL = `${environment.URL}/Search`;
  }

  public search(body: {searchText: string, filters?: TypeImpairment[]}): Observable<SearchItem[]> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.SKIP_INTERCEPTOR, '');
    return this.http.post(`${this.URL}`, body, {headers}).pipe(map(response => response as SearchItem[]));
  }
}
