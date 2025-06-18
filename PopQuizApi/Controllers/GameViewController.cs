using Microsoft.AspNetCore.Mvc;
using PopQuizApi.Models;

namespace PopQuizApi.Controllers
{
    [Route("games")]
    public class GameViewController : Controller
    {

        MyDbContext _context = new MyDbContext();

        [HttpGet("join/{id}")]
        public async Task<ActionResult<Participant>> joinGame(string id)
        {
            var game = _context.Games.ToList().Where(x => x.UniqueId == id).FirstOrDefault();

            if (game == null)
            {
                return NotFound();
            }

            if(!(game.StartTime <= DateTime.Now && game.EndTime > DateTime.Now))
            {
                return BadRequest("This games was ended");
            }




            var participant = new JoinGameRequest()
            {
                SessionId = id,



            };


            return View("JoinGame", participant);


            // return game;
        }

        [HttpGet("connect")]
        public async Task<ActionResult<Participant>> connect()
        {
           

            //if (game == null)
            //{
            //    return NotFound();
            //}

            //if (!(game.StartTime <= DateTime.Now && game.EndTime > DateTime.Now))
            //{
            //    return BadRequest("This games was ended");
            //}




            //var participant = new JoinGameRequest()
            //{
            //    SessionId = id,



            //};


            return View("TestSocket");


            // return game;
        }
    }
}
