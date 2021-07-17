import { Component } from '@angular/core';
import { CredencialLogin } from './intrergaces';
import { AuthService, ConfigService } from './services';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'ParImpar';

  constructor(private authService: AuthService, public configService: ConfigService) {
    
    // si erl usuario esta logeado esto devuelve true
    console.log(this.configService.isLooged)

    // let cedencialLogin: CredencialLogin = {
    //   user: 'test@gmail.com', 
    //   password: 'test123!',
    //   keepLoggedIn: true
    // }

    // Login
    // authService.credentialLogin(cedencialLogin).subscribe( response => {
    //   // estra logeado
    // }, error => {
    //   // error
    // });
  }
}
