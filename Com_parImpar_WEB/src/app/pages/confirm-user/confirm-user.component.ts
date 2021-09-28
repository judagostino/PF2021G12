import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { ContactService } from 'src/app/services';


@Component({
  selector: 'app-confirm-user',
  templateUrl: './confirm-user.component.html',
  styleUrls: ['./confirm-user.component.scss']
})
export class ConfirmUserComponent implements OnInit {
  message = 'Confirmado usuario…';

  constructor(private router: Router, private activatedRoute: ActivatedRoute, private contactService: ContactService ) { }

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
}
