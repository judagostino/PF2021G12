import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService, ConfigService } from 'src/app/services';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component copy.html',
  styleUrls: ['./navbar.component copy.scss']
})
export class NavbarComponent implements OnInit {
  value: string = '';

  constructor(public configService: ConfigService, private router: Router, private authService: AuthService) {
    
   }

  ngOnInit(): void {
  }

  public btn_Login(): void {
    if (!!this.configService.isLooged) {
      //this.router.navigateByUrl('/calendar');
    } else {
      this.router.navigateByUrl('/login');
    }
  }

  public btn_Logout(): void {
    this.configService.isLooged = false;
    this.configService.contact = null;
    this.authService.cleartokens();
    this.router.navigateByUrl('/login');
  }

}
