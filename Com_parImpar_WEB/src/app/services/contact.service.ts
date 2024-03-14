import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { HttpKey } from '../constans';
import { Contact, CredencialLogin } from '../interfaces';
import { ChangePassword } from '../models/change-password';
import { ContactRegistrer } from '../models/contact-register';

@Injectable({
  providedIn: 'root'
})
export class ContactService {
  URL: string = '';

  constructor(public http: HttpClient) { 
    this.URL = `${environment.URL}/Contact`;
  }

  public registrerUser(register: ContactRegistrer): Observable<any> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.SKIP_INTERCEPTOR, '');

    return this.http.post(`${this.URL}/Register`, register, {headers});
  }

  public confirmUser(register: ContactRegistrer): Observable<any> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.SKIP_INTERCEPTOR, '');

    return this.http.post(`${this.URL}/Confirm`, register, {headers});
  }

  public recoverPassword(register: ContactRegistrer): Observable<any> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.SKIP_INTERCEPTOR, '');

    return this.http.post(`${this.URL}/Recover`, register, {headers});
  }

  public denyPasswordUser(register: ContactRegistrer): Observable<any> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.SKIP_INTERCEPTOR, '');

    return this.http.post(`${this.URL}/Deny`, register, {headers});
  }

  public validateRecover(register: ContactRegistrer): Observable<any> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.SKIP_INTERCEPTOR, '');

    return this.http.post(`${this.URL}/Validate`, register, {headers});
  }

  public recoverChangePassword(register: ContactRegistrer): Observable<any> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.SKIP_INTERCEPTOR, '');

    return this.http.post(`${this.URL}/RecoverChange`, register, {headers});
  }

  public myInfo(): Observable<Contact> {
    return this.http.get(`${this.URL}/myInfo`).pipe(map( resp => {
      let contact: Contact = resp['data'];
      if(contact.description != null) {
        contact = {
          ...contact, 
          description: contact.description.replace(/<br\s*\/?>/g, '\n'),
          descriptionParagraphs: contact.description.replace(/<br\s*\/?>/g, '\n').split('\n')
        };
      }
      return contact;
    }));
  }

  public getByIdMoreInfo(id: number): Observable<Contact> {
    let headers= new HttpHeaders();

    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append(HttpKey.SKIP_INTERCEPTOR, '');

    return this.http.get(`${this.URL}/${id}`, {headers}).pipe(map((resp) => {
      let contact: Contact = resp['data'];
      if(contact.description != null) {
        contact = {
          ...contact, 
          description: contact.description.replace(/<br\s*\/?>/g, '\n'),
          descriptionParagraphs: contact.description.replace(/<br\s*\/?>/g, '\n').split('\n')
        };
      }
      return contact;
    }));
  }

  public update(body: Contact): Observable<any> {
    return this.http.put(`${this.URL}`, body);
  }  
  
  public changePassword(body: ChangePassword): Observable<any> {
    let headers= new HttpHeaders();
    headers = headers.append('Content-Type', 'application/json');
    return this.http.post(`${this.URL}/ChangePassword`, body,{headers});
  }

  public getAllContacts(): Observable<Contact []> {
    let headers= new HttpHeaders();
    headers = headers.append('Content-Type', 'application/json');
    return this.http.get(`${this.URL}/GetAll`,{headers}).pipe(map((resp) =>  resp as Contact []));
  }

  public auditor(body: Contact): Observable<any> {
    return this.http.put(`${this.URL}/${body.id}/auditor`, body);
  }  

  public trusted(contact: Contact): Observable<any> {
    return this.http.put(`${this.URL}/${contact.id}/trusted`, {});
  }  

  public untrusted(contact: Contact): Observable<any> {
    return this.http.put(`${this.URL}/${contact.id}/untrusted`, {});
  }  

  public blocked(contact: Contact): Observable<any> {
    return this.http.put(`${this.URL}/${contact.id}/blocked`, {});
  }  

  public unblocked(contact: Contact): Observable<any> {
    return this.http.put(`${this.URL}/${contact.id}/unblocked`, {});
  }  

  public deleted(credencialLogin: CredencialLogin): Observable<any> {
    return this.http.post(`${this.URL}/delete`, credencialLogin);
  }  

  public updateFoundation(body: Contact): Observable<any> {
    if(body.description != null) {
      body = {...body, description: body.description.replace(/\n/g, '<br>')};
    }
    return this.http.put(`${this.URL}/UpdateFoundation`, body);
  }  

  public deleteFoundation(): Observable<any> {
    return this.http.delete(`${this.URL}/DeleteFoundation`);
  }
}