import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';


@Injectable({
  providedIn: 'root'
})
export class ActionsLogService {
  URL: string = '';

  constructor(public http: HttpClient) { 
    this.URL = `${environment.URL}/ActionsLog`;
  }

  public getAll(): Observable<any> {
    return this.http.get(`${this.URL}`);
  }
}
