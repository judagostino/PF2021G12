import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
import { ContactService } from 'src/app/services';



@Component({
  selector: 'app-deny-recover.component',
  templateUrl: './deny-recover.component.html',
  styleUrls: ['./deny-recover.component.scss']
})
export class DenyRecoverDialogComponent implements OnInit {
  showCorrectMessage = false;
  correctMessage = '';
  showErrorMessage = false;
  errorMessage = '';
  message = '';
  


  constructor(
    public dialogRef: MatDialogRef<DenyRecoverDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: {},
    private router: Router, 
    private activatedRoute: ActivatedRoute, 
    private contactService: ContactService) {}

  ngOnInit(): void {
    this.activatedRoute.queryParams.subscribe(params => {
      this.contactService.denyPasswordUser({ id: Number.parseInt(params['i']), codeRecover: params['c']}).subscribe( () => {
        this.message='Se ha cancelado la solicitud...';
        setTimeout( () => { this.router.navigate(['/login']) }, 3000);
      })
    }, err => {
      this.message='Ocurrió un error, vuelva a intentarlo...';
    });
  }

  public closeModal():void {
    this.dialogRef.close();
  }
}
