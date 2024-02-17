import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { HttpKey } from '../constans';
import { TypeImpairment } from '../interfaces';

@Injectable({
  providedIn: 'root'
})
export class TypeImpairmentService {
  URL: string = '';

  constructor(public http: HttpClient) { 
    this.URL = `${environment.URL}/TypesImpairment`;
  }

  public getAlll(): Observable<TypeImpairment[]> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.SKIP_INTERCEPTOR, '');

    return this.http.get(`${this.URL}`, {headers}).pipe(map((response) => response['data'] as TypeImpairment[]));
  }
}
