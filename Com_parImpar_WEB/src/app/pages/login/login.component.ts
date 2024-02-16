import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
import { ConfirmUserDialogComponent } from 'src/app/components/confirm-user/confirm-user.component';
import { CredencialLogin } from 'src/app/intrergaces';
import { AuthService } from 'src/app/services';
import { ConfigService } from 'src/app/services';
import { ContactService } from 'src/app/services';


@Component({
  selector: 'app-login',
  templateUrl: './login2.component.html',
  styleUrls: ['./login2.component.scss']
})
export class LoginComponent implements OnInit {
  form: FormGroup;
  message: string;
  showError: boolean = false;

  constructor(
    private formBuilder: FormBuilder, 
    private router: Router, 
    private authService:AuthService,
    private contactService: ContactService, 
    private configService: ConfigService,
    private activatedRoute: ActivatedRoute,
    private dialog: MatDialog) { 
  }

  ngOnInit(): void {
    this.showError = false;
    this.form = this.formBuilder.group({
      user:['',Validators.required],
      password:['',Validators.required],
      keepLoggedIn: [true]
    })
    this.activatedRoute.queryParams.subscribe(params => {
      if(params['i'] != null){
        const dialogRef = this.dialog.open(
          ConfirmUserDialogComponent,
          {data:{ 
            id: Number.parseInt(params['i']), 
            confirmCode: params['c']},
            panelClass:'ModalConfirmUser'})
      }
     }
    );
  }

  public btn_login():void {
    this.showError = false;
    if(this.form.valid){
      let cedencialLogin: CredencialLogin = {
        user: this.form.value.user, 
        password: this.form.value.password,
        keepLoggedIn: true
      }
  
    
      this.authService.credentialLogin(cedencialLogin).subscribe( response => {
        return this.contactService.myInfo().subscribe(res =>{
          this.configService.contact = res;
          this.configService.isLogged = true;
          this.router.navigateByUrl('/home');
        })
        // estra logeado
      }, error => {
        this.message = 'Usuario o contraseña invalido';
        this.showError = true;
        // error
      });
    } else {
      this.message = 'Los campos son requeridos'
      this.showError = true;
    }
  }
}
