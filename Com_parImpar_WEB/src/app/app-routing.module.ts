import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { ABMEventsComponent } from './pages/abm-events/abm-events.component';
import { ABMPostsComponent } from './pages/abm-posts/abm-posts.component';
import { ActionLogComponent } from './pages/action-log/action-log.component';
import { CalendarComponent } from './pages/calendar/calendar.component';
import { ChangePasswordComponent } from './pages/change-password/change-password.component';
import { ChangeProfileComponent } from './pages/change-profile/change-profile.component';
import { ConfirmUserComponent } from './pages/confirm-user/confirm-user.component';
import { DenyRecoverComponent } from './pages/deny-recover/deny-recover.component';
import { EventsInfoComponent } from './pages/events-info/events-info.component';
import { HomeComponent } from './pages/home/home.component';
import { LoginComponent } from './pages/login/login.component';
import { ObjectTableComponent } from './pages/object-table/object-table.component';
import { PostsInfoComponent } from './pages/posts-info/posts-info.component';
import { ProfileComponent } from './pages/profile/profile.component';
import { RecoverPassordComponent } from './pages/recover-passord/recover-passord.component';
import { RegisterComponent } from './pages/register/register.component';
import { SearchComponent } from './pages/search/search.component';
import { ABMPermissionsComponent } from './pages/abm-permissions/abm-permissions.component';
import { RecoverConfirmPasswordComponent } from './pages/recover-confirm-password/recover-confirm-password.component';
import { AuthGuard } from './guard/auth.guard';
import { UnauthorizedGuard } from './guard/unauthorized.guard';


const routes: Routes = [
  {path:'login', canActivate: [UnauthorizedGuard], component: LoginComponent},
  {path:'register', canActivate: [UnauthorizedGuard], component: RegisterComponent},
  {path:'home',component: HomeComponent},
  {path:'events', canActivate: [AuthGuard], component: ABMEventsComponent},
  {path:'posts', canActivate: [AuthGuard], component: ABMPostsComponent},
  {path:'calendar',component: CalendarComponent},
  {path:'search',component: SearchComponent},
  {path:'posts-info/:id',component: PostsInfoComponent},
  {path:'events-info/:id',component: EventsInfoComponent},
  {path:'profile/:id', component: ProfileComponent},
  {path:'user/recover',component: RecoverPassordComponent},
  {path:'user/change-password', canActivate: [AuthGuard],component: ChangePasswordComponent},
  {path:'user/confirm',component: ConfirmUserComponent},
  {path:'user/cancel',component: DenyRecoverComponent},
  {path:'table/:key', canActivate: [AuthGuard], component: ObjectTableComponent},
  {path:'settings', canActivate: [AuthGuard], component: ChangeProfileComponent},
  {path:'action-log', canActivate: [AuthGuard], component: ActionLogComponent},
  {path:'user/recover-password',component: RecoverConfirmPasswordComponent},
  {path:'permissions', canActivate: [AuthGuard], component: ABMPermissionsComponent},
  {path:'**',redirectTo:"home"}
  
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
