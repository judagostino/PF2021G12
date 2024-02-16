import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute } from '@angular/router';
import { DenyRecoverDialogComponent } from 'src/app/components/deny-recover/deny-recover.component';

@Component({
  selector: 'app-home',
  templateUrl: './home2.component.html',
  styleUrls: ['./home2.component.scss']
})
export class HomeComponent implements OnInit {

  constructor(
    private activatedRoute: ActivatedRoute,
    private dialog: MatDialog 
    ) {   }

  ngOnInit(): void {
    this.activatedRoute.queryParams.subscribe(params => {
      if(params['i'] != null){
        const dialogRef = this.dialog.open(
          DenyRecoverDialogComponent,
          {data:{ 
            id: Number.parseInt(params['i']), 
            codeRecover: params['c']},
            panelClass:'ModalDenyRecover'})
      }
    }
    );
  }
}
