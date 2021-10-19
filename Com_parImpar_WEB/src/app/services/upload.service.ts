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
export class UploadService {
  URL: string = '';

  constructor(public http: HttpClient) { 
    this.URL = `${environment.URL}/Upload`;
  }

  public upload(body: any): Observable<any> {
    return this.http.post(`${this.URL}`, body);
  }
}
