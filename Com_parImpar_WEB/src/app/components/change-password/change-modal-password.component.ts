import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialogRef } from '@angular/material/dialog';
import { ChangePassword } from 'src/app/models/change-password';
import { ContactService } from 'src/app/services';
import Swal  from 'sweetalert2';

@Component({
  selector: 'app-modal-change-password',
  templateUrl: './change-modal-password.component.html',
  styleUrls: ['./change-modal-password.component.scss']
})
export class ChangeModalPasswordComponent implements OnInit {
  form: FormGroup;
  message: string;
  showError: boolean = false;

  constructor(
    private formBuilder: FormBuilder,
    private contactService: ContactService,
    public dialogRef: MatDialogRef<ChangeModalPasswordComponent>) { }

  ngOnInit(): void {
      this.initForm();
  }

  public btn_change(): void {
    this.showError = false;
    if (this.form.valid) {
      if (!this.validateFormatPassword()) {
        this.showError = true;
        this.message = 'La nueva contraseña no respeta el formato, debe tener al menos una mayúscula, una minúscula y un número.';
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
        this.contactService.changePassword(change).subscribe( resp => {
          Swal.fire(
            'Se actualizo tu contraseña',
            'El cambio comienza a surtir efecto a partir del próximo inicio de sección.',
            'success'
          ).then((result) => {
            this.dialogRef.close();
          })
        }, err => {
            console.log(err?.error)
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
            }
        });
      }
    } else {
      this.form.markAllAsTouched();
    }
  }

  public btn_cancel(): void {
    this.dialogRef.close();
  }

  private initForm(): void {
    this.form = this.formBuilder.group({ 
      lastPassword: ['', [Validators.required, Validators.minLength(8)]],
      newPassword: ['', [Validators.required, Validators.minLength(8)]],
      confirmPassword: ['', [Validators.required, Validators.minLength(8)]]
    });
    this.form.reset(new ChangePassword)
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
