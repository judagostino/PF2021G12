import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { ContactService } from 'src/app/services';


@Component({
  selector: 'app-deny-recover',
  templateUrl: './deny-recover.component.html',
  styleUrls: ['./deny-recover.component.scss']
})
export class DenyRecoverComponent implements OnInit {
  message = 'Cancelando solicitud…';

  constructor(private router: Router, private activatedRoute: ActivatedRoute, private contactService: ContactService ) { }

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

}
