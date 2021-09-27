import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ContactRegistrer } from 'src/app/models/contact-register';
import { ContactService } from 'src/app/services';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.scss']
})
export class RegisterComponent implements OnInit {
  
  form: FormGroup
  constructor( 
    private formBuilder: FormBuilder, 
    private contactService: ContactService) { }

  ngOnInit(): void {
    this.initForm();
  }

  public btn_SaveEvent(): void {
    const register = this.form.value;
    this.contactService.registrerUser(register).subscribe( () => {
      // camino corecto
    }, err => {
      // camino error
    })
  }

  public btn_NewEvent(): void {
    this.form.reset(new ContactRegistrer);
  }
  
  private initForm(): void {
    this.form = this.formBuilder.group({ 
      id: {value: null},
      email: {value: null},
      confirmEmail: {value: null},
      userName: {value: null},
      lastName: {value: null},
      firstName: {value: null},
      password: {value: null},
      confirmPassword: {value: null},
      confirmCode: {value: null},
      codeRecover: {value: null},
      dateBrirth: {value: null}
    });
    this.btn_NewEvent();
  }
}



