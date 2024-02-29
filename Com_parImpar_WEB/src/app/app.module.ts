import { BrowserModule } from '@angular/platform-browser';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { APP_INITIALIZER, LOCALE_ID, NgModule } from '@angular/core';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http'
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';

import moment from 'moment';

import { MaterialModule } from './material/material.component';

import { BlockUIModule } from 'ng-block-ui';
import { BlockUIHttpModule } from 'ng-block-ui/http';

import { ConfigService } from './services';

import { HomeComponent } from './pages/home/home.component';
import { HttpParImparInterceptor } from './interceptor/http-par-impar.interceptor';
import { LoginComponent } from './pages/login/login.component';
import { NavbarComponent } from './components/navbar/navbar.component';
import { RegisterComponent } from './pages/register/register.component';
import { ABMEventsComponent } from './pages/abm-events/abm-events.component';
import { CalendarComponent } from './pages/calendar/calendar.component';
import { RecoverPassordComponent } from './pages/recover-passord/recover-passord.component';
import { ConfirmUserComponent } from './pages/confirm-user/confirm-user.component';
import { DenyRecoverComponent } from './pages/deny-recover/deny-recover.component';
import { ChangePasswordComponent } from './pages/change-password/change-password.component';
import { SearchComponent } from './pages/search/search.component';
import { EventsInfoComponent } from './pages/events-info/events-info.component';
import { PostsInfoComponent } from './pages/posts-info/posts-info.component';
import { ProfileComponent } from './pages/profile/profile.component';
import { ABMPostsComponent } from './pages/abm-posts/abm-posts.component';
import { ObjectTableComponent } from './pages/object-table/object-table.component';
import { AuditDialogComponent } from './components/audit-dialog/audit-dialog.component';
import { ChangeProfileComponent } from './pages/change-profile/change-profile.component';
import { BlockTemplateCmp } from './components/block-template-cmp/block-template-cmp.component';
import { ActionLogComponent } from './pages/action-log/action-log.component';
import { registerLocaleData } from '@angular/common';
import localeEs from '@angular/common/locales/es';
import { NgxEchartsModule, NGX_ECHARTS_CONFIG } from 'ngx-echarts';
import { ABMPermissionsComponent } from './pages/abm-permissions/abm-permissions.component';
import { TruncatePipe } from './pipe/truncate.pipe';
import { RecoverConfirmPasswordComponent } from './pages/recover-confirm-password/recover-confirm-password.component';
import { InscriptionEventDialogComponent } from './components/inscription-event/inscription-event.component';
import { BlockUserDialogComponent } from './components/block-user/block-user.component';
import { ConfirmUserDialogComponent } from './components/confirm-user/confirm-user.component';
import { DenyRecoverDialogComponent } from './components/deny-recover/deny-recover.component';
import { DisabilitiesInterestDialogComponent } from './components/disabilities-interest/disabilities-interest.component';
import { ReasonRejectDialogComponent } from './components/reason-reject/reason-reject.component';
import { DeleteUserDialogComponent } from './components/delete-user/delete-user.component';
import { InfoContactComponent } from './pages/info-contact/info-contact.component';

registerLocaleData(localeEs, 'es');

@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    LoginComponent,
    ChangePasswordComponent,
    NavbarComponent,
    RegisterComponent,
    ABMEventsComponent,
    RecoverPassordComponent,
    ConfirmUserComponent,
    DenyRecoverComponent,
    CalendarComponent,
    SearchComponent,
    EventsInfoComponent,
    PostsInfoComponent,
    ProfileComponent,
    ABMPostsComponent,
    ObjectTableComponent,
    AuditDialogComponent,
    ChangeProfileComponent,
    ActionLogComponent,
    BlockTemplateCmp,
    ABMPermissionsComponent,
    TruncatePipe,
    RecoverConfirmPasswordComponent,
    InscriptionEventDialogComponent,
    BlockUserDialogComponent,
    ConfirmUserDialogComponent,
    DenyRecoverDialogComponent,
    DisabilitiesInterestDialogComponent,
    ReasonRejectDialogComponent,
    DeleteUserDialogComponent,
    InfoContactComponent
  ],

  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    FormsModule,
    MaterialModule,
    BrowserAnimationsModule,
    ReactiveFormsModule,
    NgxEchartsModule.forRoot({
      echarts: () => import('echarts')
    }),
    BlockUIModule.forRoot({
      template: BlockTemplateCmp,
      delayStart: 600,
      delayStop: 600
    }), // Import BlockUIModule
    BlockUIHttpModule.forRoot(), // Import Block UI Http Module
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
    {
      provide: NGX_ECHARTS_CONFIG, useValue: {
        echarts: () => import('echarts')
       }
    },
    { provide: LOCALE_ID, useValue: 'es' },
],
  entryComponents: [ BlockTemplateCmp ],
  bootstrap: [AppComponent]
})
export class AppModule {
  constructor() {
    moment.locale('es');
  }
 }

export function appInitializerFactory(config: ConfigService) {
  return () => config.load();
}