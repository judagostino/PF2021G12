import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { ContactRegistrer } from 'src/app/models/contact-register';
import { ContactService } from 'src/app/services';


@Component({
  selector: 'app-change-password',
  templateUrl: './change-password.component.html',
  styleUrls: ['./change-password.component.scss']
})
export class ChangePasswordComponent implements OnInit {
  showMessage = true;
  message = 'El tiempo ha expirado…';
  form: FormGroup;
  id: number;
  code: string;

  constructor(
     private router: Router,
     private activatedRoute: ActivatedRoute,
     private formBuilder: FormBuilder,  
     private contactService: ContactService ) { }

  ngOnInit(): void {
    this.activatedRoute.queryParams.subscribe(params => {
      this.contactService.validateRecover({ id: Number.parseInt(params['i']), codeRecover: params['c']})
      .subscribe( () =>{
        this.id=Number.parseInt(params['i']);
        this.code= params['c'];
        this.initForm();
        this.showMessage = false;
      }, error => this.showMessage = true)
    });
  }

  private initForm(): void {
    this.form = this.formBuilder.group({ 
      password: {value: null},
      confirmPassword: {value: null}
    });
  }

  public btn_change_password():void{
    const changePassword:ContactRegistrer = { ...this.form.value, id: this.id, codeRecover: this.code };
    this.contactService.recoverChangePassword(changePassword).subscribe( () => {
      setTimeout( () => { this.router.navigate(['/login']) }, 3000);
    })
  }
}
