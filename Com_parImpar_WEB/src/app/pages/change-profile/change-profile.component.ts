import { Component, ElementRef, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Router } from '@angular/router';
import moment from 'moment';
import { DeleteUserDialogComponent } from 'src/app/components/delete-user/delete-user.component';
import { DisabilitiesInterestDialogComponent } from 'src/app/components/disabilities-interest/disabilities-interest.component';
import { Contact } from 'src/app/interfaces';
import { ChangePasswordComponent } from 'src/app/pages/change-password/change-password.component';
import { AuthService, ConfigService, ContactService, UploadService } from 'src/app/services';
import Swal  from 'sweetalert2';

@Component({
  selector: 'app-change-profile',
  templateUrl: './change-profile.component-copy.html',
  styleUrls: ['./change-profile.component-copy.scss']
})
export class ChangeProfileComponent implements OnInit {
  form: FormGroup;
  formFundation: FormGroup;
  uploadForm: FormGroup;
  foundationName: string = null;
  tabSelected: 'principal' | 'foundation' = 'principal';
  @ViewChild('fileImageProfile') fileImageProfile: ElementRef;

  constructor(
    private formBuilder: FormBuilder,
    public configService: ConfigService,
    public dialog: MatDialog,
    private contactService: ContactService,
    private uploadService: UploadService,
    private router: Router, 
    private authService: AuthService,
    public snackBar: MatSnackBar,
    ) { }

  ngOnInit(): void {
    this.initForm();
    this.contactService.myInfo().subscribe(resp => {
      if (resp?.dateBrirth != null) {
        this.form.reset({...resp, dateBrirth: new Date(resp.dateBrirth).toISOString().split('T')[0]});
      } else {
        this.form.reset(resp);
      }
      if (resp != null && resp?.foundationName != null) {
        this.foundationName = resp.foundationName;
      }
      this.formFundation.reset(resp);
    })
  }

  selectTab(tabName: 'principal' | 'foundation', event: any) {
    event.preventDefault();
    this.tabSelected = tabName;
  }

  private initForm(): void {
    this.formFundation = this.formBuilder.group({
      foundationName: [''],
      address: [null],
      urlWeb: [null],
      description: [null],
      userFacebook: [null],
      userInstagram: [null],
      userLinkedin: [null],
      userX: [null],
    })
    this.form = this.formBuilder.group({
      id:{value:null},
      name:{value:null},
      auditor:{value:null},
      email: {value: '', disabled: true},
      userName: ['',  [Validators.required]],
      lastName: ['',  [Validators.required]],
      firstName: ['',  [Validators.required]],
      dateBrirth: [null],
      notifications: [true]
    })
    this.uploadForm = this.formBuilder.group({
      file: ['']
    });
  }

  public btn_SaveChange(): void {
    if(this.form.valid) { 
      const contact = this.form.value;
      this.contactService.update(contact).subscribe( resp => {
        this.contactService.myInfo().subscribe(resp2 =>{
          this.configService.contact = resp2;
          if (resp2?.dateBrirth != null) {
            this.form.reset({...resp2, dateBrirth: new Date(resp2.dateBrirth).toISOString().split('T')[0]});
          } else {
            this.form.reset(resp2);
          }
          Swal.fire(
            'Guardado',
            'Cambios realizados!',
            'success'
          )
        })
      });
      if (this.uploadForm.value != null && this.uploadForm.get('file').value != null) {
        this.uploadImage(contact.id)
      }
    } else {
      this.form.markAllAsTouched();
    }
  }

  public btn_SaveFoundation(): void {
    if (this.formFundation.value?.foundationName != null &&  this.formFundation.value?.foundationName != '') {
      let contact: Contact = this.formFundation.value;
      this.contactService.updateFoundation({...contact, id: 0}).subscribe(resp => {
        this.foundationName = contact.foundationName;
        const contact2 = this.form.value;
        if (this.uploadForm.value != null && this.uploadForm.get('file').value != null) {
          this.uploadImage(contact2.id)
        }
        this.snackBar.open('Su fundación se registro con exito','Aceptar',{duration:5000,panelClass:'snackBar-end'})
      }, errorResponse => {
        let message: string = 'Parece haber ocurrido un error, intentelo de nuevo mas tarde. si el error persiste, comuniquese con nostros.';
        
        if (errorResponse?.error != null) {
          if (errorResponse.error?.code == 5016)  {
            message = 'Parece haber ocurrido un error, debe ingresar un nombre.';
          } else if (errorResponse.error?.code == 5922)  {
            message = 'Ya existe un usuario que es responsable de esa fundación';
          }
        }
        Swal.fire(
          'Ops...',
          message,
          'error'
        )
      });
    } else {
      Swal.fire(
        'Ops...',
        'Parece haber ocurrido un error, debe ingresar un nombre.',
        'error'
      )
    }
  }

  public deleteFoundation(): void {
    Swal.fire({
      title:'¿Estás seguro?',
      text:'Esta seguro que desea dejar de ser visible como fundación',
      icon:'warning',
      showCancelButton: true,
      confirmButtonColor: '#1995AD',
      cancelButtonColor: '#1995AD',
      confirmButtonText: 'Eliminar',
      cancelButtonText: 'Cancelar'
    }).then( resoult => {
      if (resoult.isConfirmed && resoult.value == true) {
        this.contactService.deleteFoundation().subscribe( () => {
          this.foundationName = null;
          this.formFundation.reset({
            foundationName: '',
            address: null,
            urlWeb: null,
            description: null,
            userFacebook: null,
            userInstagram: null,
            userLinkedin: null,
            userX: null,
          })
          this.snackBar.open('Su fundación se dio de baja con exito','Aceptar',{duration:5000,panelClass:'snackBar-end'})
        }, err => {
          Swal.fire(
            'Ops...',
            'Parece haber ocurrido un error, intentelo de nuevo mas tarde. si el error persiste, comuniquese con nostros.',
            'error'
          )
        });
      }
    })
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

  private uploadImage(id: number) {
    if (this.uploadForm.get('file').value != null && this.uploadForm.get('file').value != '') {
      const formData = new FormData();
      formData.append('File', this.uploadForm.get('file').value);
      formData.append('Type', 'profile');
      formData.append('Id', id.toString());
  
      this.uploadService.upload(formData).subscribe((resp: {data:string}) => {
        if (resp.data != null) {
          this.configService.contact.imageUrl = resp.data.trim()+'?c='+moment().unix();
        }
      },
      (error) => {
        console.error("Error en la carga de imágenes:", error);
      });
    }
  }

    public selectImage ($event:any): void {
      $event.stopPropagation();
      this.fileImageProfile.nativeElement.click();
      }

    public onFileSelect(event:any) : void {
         const selectedFile = event.target.files[0];
         const reader = new FileReader();
         this.uploadForm.get('file').setValue(selectedFile);
         reader.onload = (e: any) => {
           this.configService.contact.imageUrl = e.target.result;
         };
         reader.readAsDataURL(selectedFile);
      }


      public openDialog(): void {
        const dialogRef = this.dialog.open(
          DisabilitiesInterestDialogComponent,
          {
            panelClass:'modalDisabilities'
          });
      } 

      public openDeleteDialog() : void {
        const dialogRef = this.dialog.open(
          DeleteUserDialogComponent,
          {
            panelClass:'modalDeleteUser'
          });
          dialogRef.afterClosed().subscribe(resp=>{
            if(resp == true){
              this.configService.isLogged = false;
              this.configService.contact = null;
              this.authService.cleartokens();
              this.router.navigateByUrl('/home');
            }
          })
      }
}
