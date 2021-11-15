import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';

@Injectable({
  providedIn: 'root'
})
export class DenyReasonService {
  URL: string = '';

  constructor(public http: HttpClient) { 
    this.URL = `${environment.URL}/DenyReason`;
  }

  public getByKeyAndId(key: string, id: number): Observable<any> {
    return this.http.get(`${this.URL}/${key}/${id}`);
  }
}
