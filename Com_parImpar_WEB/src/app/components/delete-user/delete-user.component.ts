import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Contact } from 'src/app/interfaces';


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
      this.dialogRef.close(true);
    }

    else {
      this.form.markAllAsTouched();
    }
  }

  
}
