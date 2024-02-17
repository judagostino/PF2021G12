import { Component, ElementRef, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import moment from 'moment';
import { ChangePasswordComponent } from 'src/app/pages/change-password/change-password.component';
import { ConfigService, ContactService, UploadService } from 'src/app/services';
import Swal  from 'sweetalert2';

@Component({
  selector: 'app-change-profile',
  templateUrl: './change-profile.component-copy.html',
  styleUrls: ['./change-profile.component-copy.scss']
})
export class ChangeProfileComponent implements OnInit {
  form: FormGroup;
  uploadForm: FormGroup;
  @ViewChild('fileImageProfile') fileImageProfile: ElementRef;

  constructor(
    private formBuilder: FormBuilder,
    public configService: ConfigService,
    public dialog: MatDialog,
    private contactService: ContactService,
    private uploadService: UploadService,
    ) { }

  ngOnInit(): void {
    this.initForm();
    this.contactService.myInfo().subscribe(resp =>{
      this.form.reset(resp);
    })
  }

  private initForm(): void {
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
      file: ['']
    });
  }

  public btn_SaveChange(): void {
    if(this.form.valid) { 
      const contact = this.form.value;
/*       this.contactService.update(contact).subscribe( resp => {
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
 */       if (this.uploadForm.value != null && this.uploadForm.get('file').value != null) {
          this.uploadImage(contact.id)
        
      }
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

  private uploadImage(id: number) {
    if (this.uploadForm.get('file').value != null && this.uploadForm.get('file').value != '') {
      const formData = new FormData();
      formData.append('File', this.uploadForm.get('file').value);
      formData.append('Type', 'profile');
      formData.append('Id', id.toString());
  
      this.uploadService.upload(formData).subscribe((resp: {data:string}) => {
        if (resp.data != null) {
          this.configService.contact.imageUrl = resp.data.trim()+'?c='+moment().unix;
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
      if(event.target.files.lenght > 0){
        
         }
         const selectedFile = event.target.files[0];
         const reader = new FileReader();
         this.uploadForm.get('file').setValue(selectedFile);
         reader.onload = (e: any) => {
           this.configService.contact.imageUrl = e.target.result;
         };
         reader.readAsDataURL(selectedFile);
      }
}
