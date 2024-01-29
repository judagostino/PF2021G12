import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ContactService } from 'src/app/services';
import Swal  from 'sweetalert2';


@Component({
  selector: 'app-recover-passord',
  templateUrl: './recover-passord.component copy.html',
  styleUrls: ['./recover-passord.component copy.scss']
})
export class RecoverPassordComponent implements OnInit {
  form: FormGroup;
  messageError: string;
  showError: boolean = false;

  constructor(
    private router: Router, 
    private formBuilder: FormBuilder,
    private contactService: ContactService) {  }

  ngOnInit(): void {
    this.form = this.formBuilder.group({
      email: ['', [Validators.required]],
      confirmEmail: ['', [Validators.required]],
    })
  }

  public btn_recover():void{
    this.showError = false;
    if (this.form.valid) {

      if (!this.compare('email','confirmEmail')) {
        this.showError = true;
        this.messageError = 'Los correos electrónicos no coinciden.';
      }

      if (!this.showError) {
        const recover = this.form.value;
        this.contactService.recoverPassword(recover).subscribe( () => {
          Swal.fire(
            '',
            'Se envio un correo de recuperacion',
            'success'
          )
          setTimeout( () => { this.router.navigate(['/login']) }, 3000);
        }, err => {
          this.messageError = 'A ocurrido un error al validar el correo electrónico, intentelo de nuevo mas tarde';
          this.showError = true;
          });
      }
    } else {
      this.messageError = 'Los campos son requeridos';
      this.showError = true;
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
}
