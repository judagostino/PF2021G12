import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { ABMEventsComponent } from './pages/abm-events/abm-events.component';
import { CalendarComponent } from './pages/calendar/calendar.component';
import { ChangePasswordComponent } from './pages/change-password/change-password.component';
import { ConfirmUserComponent } from './pages/confirm-user/confirm-user.component';
import { DenyRecoverComponent } from './pages/deny-recover/deny-recover.component';
import { HomeComponent } from './pages/home/home.component';
import { LoginComponent } from './pages/login/login.component';
import { RecoverPassordComponent } from './pages/recover-passord/recover-passord.component';
import { RegisterComponent } from './pages/register/register.component';

const routes: Routes = [
  {path:'login',component: LoginComponent},
  {path:'register',component: RegisterComponent},
  {path:'home',component: HomeComponent},
  {path:'events',component: ABMEventsComponent},
  {path:'calendar',component: CalendarComponent},
  {path:'user/recover',component: RecoverPassordComponent},
  {path:'user/change',component: ChangePasswordComponent},
  {path:'user/confirm',component: ConfirmUserComponent},
  {path:'user/cancel',component: DenyRecoverComponent},
  {path:'**',redirectTo:"home"}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
