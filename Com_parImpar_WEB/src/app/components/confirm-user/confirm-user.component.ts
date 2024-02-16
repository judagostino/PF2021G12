import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ContactService } from 'src/app/services';


@Component({
  selector: 'app-confirm-user.component',
  templateUrl: './confirm-user.component.html',
  styleUrls: ['./confirm-user.component.scss']
})
export class ConfirmUserDialogComponent implements OnInit {
  message = '';


  constructor(
    public dialogRef: MatDialogRef<ConfirmUserDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: {id:number,confirmCode:string,err?:string},
    private contactService: ContactService) {}

  ngOnInit(): void {
      if(this.data.err != null){
        this.message='Ocurrió un error, vuelva a intentarlo';
        return;
      }
    this.contactService.confirmUser({
        id:this.data.id,
        confirmCode:this.data.confirmCode}).subscribe( () => {
          this.message='Su usuario ha sido confirmado con éxito';
        })
  }

  public closeModal():void {
    this.dialogRef.close();
  }
}
