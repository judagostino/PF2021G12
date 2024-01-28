import { Component, OnInit } from '@angular/core';
import { AbstractControl, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ContactRegistrer } from 'src/app/models/contact-register';
import { ContactService } from 'src/app/services';
import Swal  from 'sweetalert2';

@Component({
  selector: 'app-register',
  templateUrl: './register.component copy.html',
  styleUrls: ['./register.component.scss']
})
export class RegisterComponent implements OnInit {
  
  emailPattern: any = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
  digitPattern: any= /^[0-9]+$/;
  message: string;
  showError: boolean = false;
  form: FormGroup;

  constructor( 
    private formBuilder: FormBuilder, 
    private router: Router,
    private contactService: ContactService) { }

  ngOnInit(): void {
    this.initForm();
  }

  public btn_SaveEvent(): void {
    this.showError = false;
    if(this.form.valid) { 
      const register = this.form.value;
      if (!this.validateFormatPassword()) {
        this.showError = true;
        this.message = 'La contraseña no respeta el formato, debe tener al menos una mayúscula, una minúscula y un número.';
      }

      if (!this.compare('email','confirmEmail')) {
        this.showError = true;
        this.message = 'Los correos electrónicos no coinciden.';
      }

      
      if (!this.compare('password','confirmPassword')) {
        this.showError = true;
        this.message = 'Las contraseñas no coinciden.';
      }

      if (!this.showError) {
        this.contactService.registrerUser(register).subscribe( () => {
          Swal.fire({
            title:'¡Registrado!',
            text:'Te registraste con exito',
            icon:'success',
            confirmButtonColor: "#1995AD",
          }
          )
          this.router.navigateByUrl('/login');
        }, err => {
          if (err?.error?.code != null) {
            switch(err.error.code) {
              case 5906: {
                this.showError = true;
                this.message = 'El correo electrónico ya exisite.';
                break;
              }
              default: {
                this.showError = true;
                this.message = 'Parece haber ocurrido un error, por favor intentelo de nuevo mas tarde.';
                break;
              }
            }
          }
        });
      }
   }
    else {
      this.form.markAllAsTouched();
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
      dateBrirth: [''],
    });
    
    this.form.reset(new ContactRegistrer);
  }

  compare(firstNameControl: String, twoNameControl: String){
    let firstControl = this.form.controls[firstNameControl.toString()];
    let twoControl = this.form.controls[twoNameControl.toString()];
    if(firstControl.value != null && twoControl.value != null && firstControl.value == twoControl.value) {
      return true;
    }
    else {
      return false;
    }
  }

  private validateFormatPassword(): boolean {
    let password = this.form.controls.password.value;
    let existNumber = false;
    let existCapitalLetter = false;
    let existLowerLetter = false;

    if (password != null) {
      password.split('').forEach(letter => {
        if (!isNaN(Number(letter))) {
          existNumber = true;
        }
  
        else if (letter === letter.toUpperCase()) {
          existCapitalLetter = true;
        }
  
        else if (letter === letter.toLowerCase()) {
          existLowerLetter = true;
        }
      })
  
      if (existNumber && existCapitalLetter && existLowerLetter) {
        return true;
      } else {
        return false;
      }
    }
  }
}



