import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { CredencialLogin } from 'src/app/intrergaces';
import { AuthService } from 'src/app/services';


@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {
  form: FormGroup
  constructor(private formBuilder: FormBuilder,private authService:AuthService) { 

  }

  ngOnInit(): void {
    this.form = this.formBuilder.group({
      user:[{value:null},Validators.required],
      password:[{value:null},Validators.required],
      keepLoggedIn: [true]
    })
  }

  public btn_login():void{
    if(this.form.valid){
      let cedencialLogin: CredencialLogin = {
        user: this.form.value.user, 
        password: this.form.value.password,
        keepLoggedIn: true
      }
  
    
      this.authService.credentialLogin(cedencialLogin).subscribe( response => {
        // estra logeado
      }, error => {
        // error
      });
    }
    
  }

}
