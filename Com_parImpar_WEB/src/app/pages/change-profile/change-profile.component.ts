import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import { ChangePasswordComponent } from 'src/app/pages/change-password/change-password.component';
import { ConfigService, ContactService } from 'src/app/services';
import Swal  from 'sweetalert2';

@Component({
  selector: 'app-change-profile',
  templateUrl: './change-profile.component-copy.html',
  styleUrls: ['./change-profile.component-copy.scss']
})
export class ChangeProfileComponent implements OnInit {
  form: FormGroup;

  constructor(
    private formBuilder: FormBuilder,
    public configService: ConfigService,
    public dialog: MatDialog,
    private contactService: ContactService) { }

  ngOnInit(): void {
    this.initForm();

  }

  private initForm(): void {
    this.form = this.formBuilder.group({
      email: {value: '', disabled: true},
      userName: ['',  [Validators.required]],
      lastName: ['',  [Validators.required]],
      firstName: ['',  [Validators.required]],
      dateBrirth: [null],
      notifications: [true]
    })
    setTimeout( () => this.form.reset(this.configService.contact), 500)
  }

  public btn_SaveChange(): void {
    if(this.form.valid) { 
      const contact = this.form.value;
      this.contactService.update(contact).subscribe( resp => {
        this.contactService.myInfo().subscribe(res =>{
          this.configService.contact = res;
          this.form.reset(res)
          Swal.fire(
            'Guardado',
            'Cambios realizados!',
            'success'
          )
        })
      });
    } else {
      this.form.markAllAsTouched();
    }
  }

  public getImage(): string {
    if (this.configService.contact != null && this.configService.contact.imageUrl != null) {
      return this.configService.contact.imageUrl.trim();
    } else {
      return '/assets/image/user.png';
    }
  }

  public btn_ChangePass(): void {
    const dialogRef = this.dialog.open(ChangePasswordComponent,
      {
        width: '700px',
        height: '400px'
      });
  } 
}
