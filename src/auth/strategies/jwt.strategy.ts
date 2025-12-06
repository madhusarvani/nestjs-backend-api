import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(configService: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: 'test-secret-key-do-not-use-in-production',
    });
  }

  async validate(payload: any) {
    console.log('JWT Validated:', payload);
    return { 
      userId: payload.sub, 
      email: payload.email,
      isAdmin: payload.isAdmin || false 
    };
  }
}
