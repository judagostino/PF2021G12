import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';


@Component({
  selector: 'app-reason-reject',
  templateUrl: './reason-reject.component.html',
  styleUrls: ['./reason-reject.component.scss']
})
export class ReasonRejectDialogComponent implements OnInit {
  reason = '';

  constructor(
    public dialogRef: MatDialogRef<ReasonRejectDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: {reason?:string}) {}

  ngOnInit(): void {
    if(this.data != null){
      if(this.data.reason){
            this.reason = this.data.reason;
          }
        }
      }  
  

  public closeModal():void {
    this.dialogRef.close();
  }
}
