import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { Console } from 'console';
import { ChangePassword } from 'src/app/models/change-password';
import { ContactRegistrer } from 'src/app/models/contact-register';
import { ContactService } from 'src/app/services';
import Swal  from 'sweetalert2';


@Component({
  selector: 'app-change-password',
  templateUrl: './change-password.component copy.html',
  styleUrls: ['./change-password.component copy.scss']
})
export class ChangePasswordComponent implements OnInit {
  showMessage = true;
  message;
  form: FormGroup;
  id: number;
  code: string;
  messageError: string;
  showError: boolean = false;

  constructor(
     private router: Router,
     private activatedRoute: ActivatedRoute,
     private formBuilder: FormBuilder,  
     private contactService: ContactService ) { }

  ngOnInit(): void {
    this.initForm();
    this.showMessage = false;

  }

  private initForm(): void {
    this.form = this.formBuilder.group({ 
      lastPassword: ['', [Validators.required, Validators.minLength(8)]],
      newPassword: ['', [Validators.required, Validators.minLength(8)]],
      confirmPassword: ['', [Validators.required, Validators.minLength(8)]]
    });
    this.form.reset(new ChangePassword)

  }

  public btn_change_password():void{
    this.showError = false;
    if (this.form.valid) {

      if (!this.validateFormatPassword()) {
        this.showError = true;
        this.messageError = 'La contraseña no cumple con alguna de las políticas de seguridad establecidas, debe tener al menos una mayúscula, una minúscula, un número y poseer como mínimo 8 caracteres.';
      }

      if (!this.compare('newPassword','confirmPassword')) {
        this.showError = true;
        this.message = 'La nueva contraseña no coinciden.';
      }

      if (this.compare('lastPassword','newPassword')) {
          this.showError = true;
          this.message = 'La nueva contraseña es igual a la antigua.';
      }

      if (!this.showError) {
        let change : ChangePassword = this.form.value;
        console.log(change)
        /* this.contactService.changePassword(change).subscribe( () => {
          Swal.fire(
            'Se actualizo tu contraseña',
            'El cambio comienza a surtir efecto a partir del próximo inicio de sesión.',
            'success'
          );
          setTimeout( () => { this.router.navigate(['/settings']) }, 3000);
        }, err => {
        console.log(err)
        if (err?.error?.code != null) {
          switch(err.error.code) {
            case 5911: {
              this.showError = true;
              this.message = 'La nueva contraseña es igual a la antigua.';
              break;
            }
            default: {
              this.showError = true;
              this.message = 'Parece haber ocurrido un error, por favor intentelo de nuevo mas tarde.';
              break;
            }
              }
        }}) */
      }
    } else {
      this.form.markAllAsTouched();
    }
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
    let password = this.form.controls.newPassword.value;
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
