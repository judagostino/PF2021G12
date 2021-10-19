import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { AbstractControl, FormBuilder, FormGroup, Validators } from '@angular/forms';
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
  
  emailPattern: any = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
  digitPattern: any= /^[0-9]+$/;

  form: FormGroup
  constructor( 
    private formBuilder: FormBuilder, 
    private router: Router,
    private contactService: ContactService) { }

  ngOnInit(): void {
    this.initForm();
  }

  public btn_SaveEvent(): void {
    if(this.form.valid) { 
    const register = this.form.value;
    this.contactService.registrerUser(register).subscribe( () => {
      // camino corecto
      Swal.fire(
        '¡Registrado!',
        'Te registraste con exito',
        'success'
      )
      this.router.navigateByUrl('/login');
      this.validateFormatPassword('password');
    }, err => {
      // camino error
    })
  }
  else {
    this.form.markAllAsTouched;
  }
  }

  public btn_NewEvent(): void {
    this.router.navigateByUrl('/login');
  }
  
  private initForm(): void {
    this.form = this.formBuilder.group({
      id: [''],
      email: ['', [Validators.required, Validators.email]],
      confirmEmail: ['', [Validators.required, Validators.pattern(this.emailPattern)]],
      userName: ['',  [Validators.required]],
      lastName: ['',  [Validators.required]],
      firstName: ['',  [Validators.required]],
      password: ['', [Validators.required, Validators.minLength(8)]],
      confirmPassword: ['', [Validators.required, Validators.minLength(8)]],
      confirmCode: ['', [Validators.required]],
      codeRecover: ['', [Validators.required]],
      dateBrirth: ['', [Validators.required]],
    }, {
      // Validator: this.compare('email', 'confirmEmail')
      // Validator2: this.compare('password', 'confirmPassword')

    });
    
    this.form.reset(new ContactRegistrer);
  }

  compare(firstNameControl: String, twoNameControl: String){
    let firstControl = this.form.controls[firstNameControl.toString()];
    let twoControl = this.form.controls[twoNameControl.toString()];
    if(firstControl.value != null && twoControl.value != null && firstControl.value == twoControl.value){
      twoControl.setErrors({distint: true});
      return {distint: true}
    }
    else {
      twoControl.setErrors(null);
      return null
    }
  }

  get emailField(){
    return this.form.get('email');
  }

  get confirmEmailField(){
    return this.form.get('confirmEmail');
  }

  get passwordField(){
    return this.form.get('password');
  }

  get confirmPasswordField(){
    return this.form.get('confirmPassword');
  }

  private validateFormatPassword(password: String): boolean
  { 
    let existNumber = false;
    let existCapitalLetter = false;
    let existLowerLetter = false;


    password.split('').forEach(letter => {
      if (!isNaN(Number(letter)))
      {
        existNumber = true;
      }

      else if (letter === letter.toUpperCase())
      {
        existCapitalLetter = true;
      }

      else if (letter === letter.toLowerCase())
      {
        existLowerLetter = true;
      }
    })

    if (existNumber && existCapitalLetter && existLowerLetter)
    {
      return true;
    }
    else
    {
      return false;
    }

  }
}



