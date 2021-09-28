import { BrowserModule } from '@angular/platform-browser';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { APP_INITIALIZER, NgModule } from '@angular/core';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http'

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';

import { HomeComponent } from './pages/home/home.component';
import { HttpParImparInterceptor } from './interceptor/http-par-impar.interceptor';
import { ConfigService } from './services';
import { LoginComponent } from './pages/login/login.component';
import { NavbarComponent } from './components/navbar/navbar.component';
import { RegisterComponent } from './pages/register/register.component';
import { ABMEventsComponent } from './pages/abm-events/abm-events.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MaterialModule } from './material/material.component';
import { FooterComponent } from './components/footer/footer.component';
import { CalendarComponent } from './pages/calendar/calendar.component';
import { RecoverPassordComponent } from './pages/recover-passord/recover-passord.component';
import { ConfirmUserComponent } from './pages/confirm-user/confirm-user.component';
import { DenyRecoverComponent } from './pages/deny-recover/deny-recover.component';
import { ChangePasswordComponent } from './pages/change-password/change-password.component';

@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    LoginComponent,
    ChangePasswordComponent,
    NavbarComponent,
    RegisterComponent,
    ABMEventsComponent,
    FooterComponent,
    RecoverPassordComponent,
    ConfirmUserComponent,
    DenyRecoverComponent,
    CalendarComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    FormsModule,
    MaterialModule,
    BrowserAnimationsModule,
    ReactiveFormsModule
  ],
  providers: [
    ConfigService,
    HttpParImparInterceptor,
    {
      provide: HTTP_INTERCEPTORS,
      useClass: HttpParImparInterceptor,
      multi: true
    },
    {
      provide: APP_INITIALIZER,
      useFactory: appInitializerFactory,
      multi: true,
      deps: [ConfigService]
    },
],
  bootstrap: [AppComponent]
})
export class AppModule { }

export function appInitializerFactory(config: ConfigService) {
  return () => config.load();
}