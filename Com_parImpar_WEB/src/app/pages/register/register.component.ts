import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
import { ContactRegistrer } from 'src/app/models/contact-register';
import { ContactService } from 'src/app/services';
import Swal  from 'sweetalert2';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.scss']
})
export class RegisterComponent implements OnInit {
  
  form: FormGroup
  constructor( 
    private formBuilder: FormBuilder, 
    private router: Router,
    private contactService: ContactService) { }

  ngOnInit(): void {
    this.initForm();
  }

  public btn_SaveEvent(): void {
    const register = this.form.value;
    this.contactService.registrerUser(register).subscribe( () => {
      // camino corecto
      Swal.fire(
        '¡Registrado!',
        'Te registraste con exito',
        'success'
      )
      this.router.navigateByUrl('/login');
    }, err => {
      // camino error
    })
  }

  public btn_NewEvent(): void {
    this.router.navigateByUrl('/login');
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
    this.form.reset(new ContactRegistrer);
  }
}



