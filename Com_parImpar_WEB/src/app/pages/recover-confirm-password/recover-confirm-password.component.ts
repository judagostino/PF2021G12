import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { ContactService } from 'src/app/services';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import Swal  from 'sweetalert2';
import { ContactRegistrer } from 'src/app/models/contact-register';


@Component({
  selector: 'app-recover-confirm-password',
  templateUrl: './recover-confirm-password.component.html',
  styleUrls: ['./recover-confirm-password.component.scss']
})
export class RecoverConfirmPasswordComponent implements OnInit {
  showMessage = true;
  message = 'El tiempo ha expirado…';
  form: FormGroup;
  id: number;
  code: string;
messageError: string;
  showError: boolean = false;

  constructor(
    public activatedRoute:ActivatedRoute,
    public contactService:ContactService,
    public formBuilder:FormBuilder,
    private router: Router,){

  }

  ngOnInit(): void {
    this.activatedRoute.queryParams.subscribe(params => {
      this.contactService.validateRecover({ id: Number.parseInt(params['i']), codeRecover: params['c']})
      .subscribe( () =>{
        this.id=Number.parseInt(params['i']);
        this.code= params['c'];
        this.initForm();
        this.showMessage = false;
      }, error => this.showMessage = true)
    });

  }

  private initForm(): void {
    this.form = this.formBuilder.group({ 
      password: [null,[Validators.required]],
      confirmPassword: [null,[Validators.required]]
    });
  }

public btn_change_password():void{
  this.showError = false;
  if (this.form.valid) {

    if (!this.validateFormatPassword()) {
      this.showError = true;
      this.messageError = 'La contraseña no cumple con alguna de las políticas de seguridad establecidas, debe tener al menos una mayúscula, una minúscula, un número y poseer como mínimo 8 caracteres.';
    }

    if (!this.compare('password','confirmPassword')) {
      this.showError = true;
      this.messageError = 'Los contraseñas no coinciden.';
    }

    if (!this.showError) {
      const changePassword:ContactRegistrer = { ...this.form.value, id: this.id, codeRecover: this.code };
      this.contactService.recoverChangePassword(changePassword).subscribe( () => {
        Swal.fire(
          '',
          'Se actualizo tu contraseña',
          'success'
        );
        setTimeout( () => { this.router.navigate(['/login']) }, 3000);
      }, err => {
      this.messageError = 'La contraseña no cumple con alguna de las políticas de seguridad establecidas, debe tener al menos una mayúscula, una minúscula, un número y poseer como mínimo 8 caracteres.';
      this.showError = true;
      })
    }
  } else {
    this.messageError = 'Los campos son requeridos';
    this.showError = true;
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
