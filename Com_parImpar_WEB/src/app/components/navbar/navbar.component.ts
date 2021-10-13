import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ConfigService } from 'src/app/services';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.scss']
})
export class NavbarComponent implements OnInit {
  value: string = '';

  constructor(public configService: ConfigService, private router: Router) {
    
   }

  ngOnInit(): void {
  }

  public btn_Login(): void {
    if (!!this.configService.isLooged) {
      this.router.navigateByUrl('/calendar');
    } else {
      this.router.navigateByUrl('/login');
    }
  }
}
