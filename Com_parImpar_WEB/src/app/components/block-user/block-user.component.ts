import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Contact } from 'src/app/interfaces';


@Component({
  selector: 'app-block-user',
  templateUrl: './block-user.component.html',
  styleUrls: ['./block-user.component.scss']
})
export class BlockUserDialogComponent implements OnInit {
 contact:Contact

  constructor(
    public dialogRef: MatDialogRef<BlockUserDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: {contact?:Contact}) {}

  ngOnInit(): void {
    if(this.data.contact != null){
      this.contact = this.data.contact
    }
  }
    

  public closeModal():void {
    this.dialogRef.close(false);
  }

  public btn_YesBlockUser():void{
    this.dialogRef.close(true);
  }

  public btn_NoBlockUser():void {
    this.dialogRef.close(false);
  }
}
