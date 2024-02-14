import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
import { ContactService } from 'src/app/services';


@Component({
  selector: 'app-confirm-user.component',
  templateUrl: './confirm-user.component.html',
  styleUrls: ['./confirm-user.component.scss']
})
export class ConfirmUserDialogComponent implements OnInit {
  showCorrectMessage = false;
  correctMessage = '';
  showErrorMessage = false;
  errorMessage = '';
  message = '';


  constructor(
    public dialogRef: MatDialogRef<ConfirmUserDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: {},
    private router: Router, 
    private activatedRoute: ActivatedRoute, 
    private contactService: ContactService) {}

  ngOnInit(): void {
    this.activatedRoute.queryParams.subscribe(params => {
      this.contactService.confirmUser({ id: Number.parseInt(params['i']), confirmCode: params['c']}).subscribe( () => {
        this.message='Usuario confirmado con éxito, redirigiendo al Login...';
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
