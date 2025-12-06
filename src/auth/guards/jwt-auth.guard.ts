import { Injectable, ExecutionContext } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { Observable } from 'rxjs';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
  canActivate(context: ExecutionContext): boolean | Promise<boolean> | Observable<boolean> {
    console.log('JwtAuthGuard: Checking authentication...');
    return super.canActivate(context);
  }

  handleRequest(err: any, user: any, info: any) {
    console.log('JwtAuthGuard: User from token:', user);
    if (err || !user) {
      console.log('JwtAuthGuard: Authentication failed', err || 'No user');
      throw err || new Error('Unauthorized');
    }
    return user;
  }
}
