import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ContactService } from 'src/app/services';

@Component({
  selector: 'app-deny-recover.component',
  templateUrl: './deny-recover.component.html',
  styleUrls: ['./deny-recover.component.scss']
})
export class DenyRecoverDialogComponent implements OnInit {
  message = '';

  constructor(
    public dialogRef: MatDialogRef<DenyRecoverDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: {id:number,codeRecover:string},
    private contactService: ContactService) {}

  ngOnInit(): void {
    this.contactService.denyPasswordUser({ 
      id:this.data.id,
      codeRecover:this.data.codeRecover}).subscribe( () => {
      this.message='Se ha cancelado la solicitud...';
    })
  }

  public closeModal():void {
    this.dialogRef.close();
  }
}
