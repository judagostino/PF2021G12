import { Component, OnInit } from '@angular/core';
import { ConfigService } from 'src/app/services';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.scss']
})
export class NavbarComponent implements OnInit {
  value: string = '';

  constructor(public configService: ConfigService) {
    
   }

  ngOnInit(): void {
  }

}
