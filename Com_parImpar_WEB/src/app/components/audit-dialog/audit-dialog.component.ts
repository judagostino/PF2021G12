import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Contact } from 'src/app/intrergaces';
import { Events } from 'src/app/models/events';
import { Post } from 'src/app/models/post';
import { ConfigService, DenyReasonService } from 'src/app/services';
import Swal  from 'sweetalert2';

@Component({
  selector: 'app-audit-dialog',
  templateUrl: './audit-dialog.component.html',
  styleUrls: ['./audit-dialog.component.scss']
})
export class AuditDialogComponent implements OnInit {
  eventElement: Events;
  post: Post;
  paragaphs: string[] = [];
  autor: Contact;
  reason: string= '';

  constructor(
    private configService: ConfigService,
    private denyReasonService: DenyReasonService,
    public dialogRef: MatDialogRef<AuditDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: {post?: Post, event?: Events, authorize?: boolean, reason: string}) { }

  ngOnInit(): void {
    if (this.data != null) {
      if (this.data.event != null) {
        this.eventElement = this.data.event;
        this.post = null;
        this.autor = this.eventElement.contactCreate
        this.getState();
      } else if (this.data.post != null) {
        this.eventElement = null;
        this.post = this.data.post;
        this.autor = this.post.contactCreate
        this.paragaphs = [this.post.text.substr(0,100), this.post.text.substr(100,170), this.post.text.substr(170,300), this.post.text.substr(300,700), this.post.text.substr(700,1000)].concat( this.post.text.substr(1000,this.post.text.length).split('. A'))
        this.getState();
      }
    }
  }


  public getImage(): string {
    if (this.eventElement != null && this.eventElement.imageUrl != null) {
      return this.eventElement.imageUrl.trim();
    }
    else if (this.post != null && this.post.imageUrl != null) {
      return this.post.imageUrl.trim();
    }
    else {
      return this.configService.dafaultImage();
    }
  }

  public btn_Authorize(): void {
    this.dialogRef.close(JSON.stringify({
      ...this.data,
      authorize: true 
    }));
  }

  public btn_Deny(): void {
   this.openmodalReason();
  }

  private getState() {
    let key: string;
    let id: number;

    if (this.eventElement != null && this.eventElement.state.id  == 3) {
      key = 'EventId';
      id = this.eventElement.id;
    }
    else if (this.post != null && this.post.state.id  == 3) {
      key = 'PostId';
      id = this.post.id;
    }
  
    if (key != null && id != null) {
      this.denyReasonService.getByKeyAndId(key,id).subscribe((respose: {reason:string})=> {
        if (respose != null && respose.reason != null) {
          this.reason = respose.reason
        }
      });
    } else {
      this.reason = '';
    }

  }

  private openmodalReason(): void {
    Swal.fire({
      title: 'Motivo del rechazo.',
      input: 'text',
      inputAttributes: {
        autocapitalize: 'off'
      },
      showCancelButton: true,
      confirmButtonColor: '#3f51b5',
      cancelButtonColor: '#f44336',
      confirmButtonText: 'Rechazar',
      showLoaderOnConfirm: true,
      cancelButtonText: 'Cancelar'
    }).then((result) => {
      console.log(result)
      if (result.isConfirmed) {
        this.dialogRef.close(JSON.stringify({
          ...this.data,
          authorize: false,
          reason: result.value
        }));
      }
    })
  }
}
