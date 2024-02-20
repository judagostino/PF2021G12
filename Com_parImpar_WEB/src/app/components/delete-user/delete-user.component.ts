import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Contact } from 'src/app/interfaces';
import { ContactService } from 'src/app/services';


@Component({
  selector: 'app-delete-user',
  templateUrl: './delete-user.component.html',
  styleUrls: ['./delete-user.component.scss']
})
export class DeleteUserDialogComponent implements OnInit {
  form:FormGroup;

  
  constructor(
    private formBuilder:FormBuilder,
    public dialogRef: MatDialogRef<DeleteUserDialogComponent>,
    public contactService:ContactService,
    public snackBar:MatSnackBar,

    ) {}

  ngOnInit(): void {
    this.form = this.formBuilder.group({
      password:[null,[Validators.required]]
    })
  }
    
  public closeModal():void {
    this.dialogRef.close(false);
  }

  public btn_delete():void{
    if(this.form.valid){
      this.contactService.deleted(this.form.value).subscribe(resp =>{
        this.snackBar.open('Su usuario ha sido eliminado con éxito','Aceptar',{duration:5000,panelClass:'snackBar-end'})
        this.dialogRef.close(true);
      },
      err =>{
        switch(err?.error?.code){
          case 5921:{
            this.snackBar.open('La contraseña es incorrecta','Aceptar',{duration:3000,panelClass:'snackBar-end'})
            break;
          }
          case 5002:{
            this.snackBar.open('La contraseña es requerida','Aceptar',{duration:3000,panelClass:'snackBar-end'})
            break;
          }
          default:{
            this.snackBar.open('Hubo un problema al eliminar el usuario, intentelo más tarde','Aceptar',{duration:3000,panelClass:'snackBar-end'})
            break;
          }
        }
      });
    }

    else {
      this.form.markAllAsTouched();
    }
  }

  
}
